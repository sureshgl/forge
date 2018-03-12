package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Struct_unionContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Struct_unionContextExt extends AbstractBaseExt {

	public Struct_unionContextExt(Struct_unionContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Struct_unionContext getContext() {
		return (Struct_unionContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).struct_union());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Struct_unionContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + Struct_unionContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}