package com.forge.parser.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.parser.PopulateExtendedContextVisitor;
import com.forge.parser.gen.ForgeParser.Slave_propertiesContext;

public class Slave_propertiesContextExt extends AbstractBaseExt {

	public Slave_propertiesContextExt(Slave_propertiesContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Slave_propertiesContext getContext() {
		return (Slave_propertiesContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).slave_properties());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Slave_propertiesContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Slave_propertiesContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}
