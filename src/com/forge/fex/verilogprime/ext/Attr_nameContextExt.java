package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Attr_nameContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Attr_nameContextExt extends AbstractBaseExt {

	public Attr_nameContextExt(Attr_nameContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Attr_nameContext getContext() {
		return (Attr_nameContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).attr_name());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Attr_nameContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + Attr_nameContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}