package com.forge.parser.ext;

import java.util.List;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.parser.PopulateExtendedContextVisitor;
import com.forge.parser.gen.ForgeParser.Slave_nameContext;

public class Slave_nameContextExt extends AbstractBaseExt {

	public Slave_nameContextExt(Slave_nameContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Slave_nameContext getContext() {
		return (Slave_nameContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).slave_name());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Slave_nameContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Slave_nameContextExt.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
	
	public void collectModulesToStitchForTop(List<String> chain){
		chain.add(getFormattedText());
	}
}
