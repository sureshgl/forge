package com.forge.parser.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.parser.PopulateExtendedContextVisitor;
import com.forge.parser.gen.ForgeParser.Read_attrContext;

public class Read_attrContextExt extends AbstractBaseExt {

	public Read_attrContextExt(Read_attrContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Read_attrContext getContext() {
		return (Read_attrContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).read_attr());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Read_attrContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + Read_attrContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}