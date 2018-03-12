package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Ref_declarationContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Ref_declarationContextExt extends AbstractBaseExt {

	public Ref_declarationContextExt(Ref_declarationContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Ref_declarationContext getContext() {
		return (Ref_declarationContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).ref_declaration());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Ref_declarationContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Ref_declarationContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}